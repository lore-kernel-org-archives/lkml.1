Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbXHWPad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbXHWPad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764098AbXHWPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:30:20 -0400
Received: from main.gmane.org ([80.91.229.2]:33670 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763177AbXHWPaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:30:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: what does this mean: "kernel: 7.0.0.1:53 L=79 S=0x00 I=39869
   F=0x4000 T=64"
Date: Thu, 23 Aug 2007 21:30:36 +0600
Message-ID: <46CDA81C.4060705@ums.usu.ru>
References: <20070823100045.GA18793@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 212.220.80.122
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
In-Reply-To: <20070823100045.GA18793@piper.oerlikon.madduck.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

martin f krafft wrote:
> I am staring at this log message:
> 
>   kernel: 7.0.0.1:53 L=79 S=0x00 I=39869 F=0x4000 T=64
> 
> and I cannot figure out what it's trying to tell me. Could someone
> please enlighten me?

Looks like some DNS packet got logged by your firewall rules.

-- 
Alexander E. Patrakov

