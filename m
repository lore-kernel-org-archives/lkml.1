Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYAXQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYAXQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYAXQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:25:07 -0500
Received: from main.gmane.org ([80.91.229.2]:58467 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbYAXQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:25:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Massive IDE problems. Who leaves data here?
Date: Thu, 24 Jan 2008 17:29:59 +0100
Message-ID: <4798BD07.4040505@nurfuerspam.de>
References: <fn5ivo$ck2$1@ger.gmane.org>	<47965138.8060603@garzik.org>	<fn5jsn$ful$1@ger.gmane.org> <20080122222539.5643d6ae@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4ba1f.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.11) Gecko/20071129 SeaMonkey/1.1.7
In-Reply-To: <20080122222539.5643d6ae@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Yes, or dodgy connectors or other problems. The CRC itself is computed by
> the hardware each end so a BadCRC error really means the two ends
> disagree about the data. 

I'll have a closer look at the connectors, but as I replaced the whole 
cable for the fourth time, today, I don't think, that the connectors are 
the reason. Plugging in and out should have cleaned the connectors.

> That is *usually* a cable/electrical noise problem. It can be power and
> it can occasionally show up if the software misprograms the timing so the
> two ends are a bit out of sync.

Even if it *would* be a timing problem, I would be unable to debug or 
fix this.

Yours

Manuel

