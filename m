Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbYBTQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbYBTQhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934454AbYBTQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:27:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37100 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934443AbYBTQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=fab5mfVu1FYNMOsIFKTmA4lv+y3GnwT0ZJm3t2hsiNUgP9gwaFrG/H92gNUbU73/lXsNOveBBiwhbJBxR2wKEj2xYvB35sd1CLMKlVfdo3jh58fPKgZeOy/h+MW3XxmRhEXy/OwMCoBSrI/fnYgjgILulidjN69YRDEPC6n5x/4=
Date: Wed, 20 Feb 2008 16:28:01 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [2.6 patch] make stk_camera_{suspend,resume}() static
Message-ID: <20080220162801.GA4430@singular.sob>
References: <20080219192908.GF31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080219192908.GF31955@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El mar. 19 de feb. de 2008, a las 21:29:08 +0200, Adrian Bunk escribió:
> This patch makes the needlessly global stk_camera_{suspend,resume}() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>

thanks
