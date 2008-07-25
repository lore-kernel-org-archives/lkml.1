Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYGYBO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYGYBO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYGYBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:14:17 -0400
Received: from ozlabs.org ([203.10.76.45]:54205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYGYBOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:14:17 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Date: Fri, 25 Jul 2008 11:11:26 +1000
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1216887460.306306.238738123378.1.gpush@pingu> <200807250108.m6P18f4B099179@sullivan.realtime.net>
In-Reply-To: <200807250108.m6P18f4B099179@sullivan.realtime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251111.26673.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton,

> Yes.  How about all dtbImage, zImage, cuboot, treeboot, etc
> that are newer than vmlinux?

The existing arch code doesn't do any checks for timestamps, perhaps 
this would be better implemented as an arch-independent change?

(but would you like me to add treeboot and cuboot?)

Cheers,


Jeremy
