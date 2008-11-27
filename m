Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYK0Oq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYK0Oq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYK0OqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:46:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:45985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752502AbYK0OqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:46:15 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18ortVoI7Eo8guB8CCh1ntv45svl/8+Cueb+eEypw
	V2wjIY4GuuYomD
Date: Thu, 27 Nov 2008 15:46:24 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] LEDs: allow led-drivers to use a wider than 0...255
 range of brightness values
In-Reply-To: <20081127143055.GA4678@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0811271543430.4204@axis700.grange>
References: <Pine.LNX.4.64.0811251751480.6290@axis700.grange>
 <20081125180241.GA4783@khazad-dum.debian.net> <Pine.LNX.4.64.0811261535590.4749@axis700.grange>
 <20081127143055.GA4678@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Henrique de Moraes Holschuh wrote:

> On Wed, 26 Nov 2008, Guennadi Liakhovetski wrote:
> > Would you then have to do "echo 100.5 > brightness"?...
> 
> Or add an integer attribute for the fractional part (which takes some
> thought to do correctly), since fp is frowned upon in sysfs...

Emn, sorry, actually, that was supposed to be a joke:-) I would have to be 
_very_ hungry to programme that:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
