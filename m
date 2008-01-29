Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbYA2RKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbYA2RKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYA2RKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:10:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:49002 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740AbYA2RK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=cuNL92pwXE9d04BIS1ixwr20udAZq5YIP6RleY5WPN5tfteECUDpsCRHKMcID22FMAH13CgJvoUfaKnd39AT1GMGBc5tbsCSrvCL2872law2N+Amvfs1EZr6L5j50NIv4NtdIvEBgJG8QGFe3zjUZ8fUUzswoyAYPbp+ysG534s=
Date: Tue, 29 Jan 2008 17:10:29 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] stk-sensor.c: make 2 functions static
Message-ID: <20080129171029.GA4816@singular.sob>
References: <20080128221058.GT8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080128221058.GT8767@does.not.exist>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El mar. 29 de ene. de 2008, a las 00:10:58 +0200, Adrian Bunk escribió:
> This patch makes the following needlessly global functions static:
> - stk_sensor_outb()
> - stk_sensor_inb()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>
