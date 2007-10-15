Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbXJOQw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbXJOQw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXJOQwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:52:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39316 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbXJOQwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:52:19 -0400
Date: Mon, 15 Oct 2007 18:52:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Philippe Elie <phil.el@wanadoo.fr>
cc: Sam Ravnborg <sam@ravnborg.org>, Rik van Riel <riel@surriel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: <20071015163655.GB2884@zaniah>
Message-ID: <Pine.LNX.4.64.0710151851180.10197@fbirervta.pbzchgretzou.qr>
References: <20071014190128.6e3cdb44@bree.surriel.com>
 <20071015142352.GA21259@uranus.ravnborg.org> <20071015163154.GA2884@zaniah>
 <20071015163655.GB2884@zaniah>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 15 2007 18:36, Philippe Elie wrote:
>> 
>> Isn't make -j 2 or more implemented by running multiple make in sub-dirs ?
>> Parallel make is more and more used even on cheap hardware.
>
>Errm, I misread what you said, it can be a single Makefile in each sub-dirs

Even now, make -j8 really pays off on bigiron AMD.
