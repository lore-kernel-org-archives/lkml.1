Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbXLUCKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbXLUCKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbXLUCJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:09:09 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:62240 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbXLUCJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:09:07 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Fri, 21 Dec 2007 03:09:02 +0100
User-Agent: KMail/1.9.7
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712201912.37416.volker.armin.hemmann@tu-clausthal.de> <20071220190419.GA23620@elte.hu>
In-Reply-To: <20071220190419.GA23620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712210309.02865.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so after the holidays I will do the following:

let memtest86+ run several hours.
do a full backup&restore to switch to r3 and build an unpatched kernel.
see if I can reproduce the oops with .21 and .22 (because AFAIR no oops with 
21.. but I might be wrong).

Not exactly in that order.

Glück Auf
Volker


ps: please cc me. I am not subscribed to lkml.
