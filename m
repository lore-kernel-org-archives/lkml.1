Return-Path: <linux-kernel-owner+w=401wt.eu-S933542AbYA2RL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbYA2RL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYA2RLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:11:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:51173 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYA2RLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=F27DwTb6bRI3J1+sQ98IUMLGU7p5Oo+e1OdKb8NLRNLGbuMidT1XstoTRLz3SJF6Ky6RHzPg2F9TgQrKMmKZUxRY5BEn25H6Ko2ya21QKRqytbR8a5DN9pHLIifvVkCt1tCSbxsjcpXr4ZL8FmvjgZmy006e6+uN8JzPrCjoCXg=
Date: Tue, 29 Jan 2008 17:11:17 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make stk_camera_cleanup() static
Message-ID: <20080129171117.GB4816@singular.sob>
References: <20080128221101.GU8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080128221101.GU8767@does.not.exist>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El mar. 29 de ene. de 2008, a las 00:11:01 +0200, Adrian Bunk escribió:
> stk_camera_cleanup() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>
