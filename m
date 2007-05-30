Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXE3PAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXE3PAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXE3PAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:00:37 -0400
Received: from mtaout4.012.net.il ([84.95.2.10]:11084 "EHLO mtaout4.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXE3PAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:00:36 -0400
Date: Wed, 30 May 2007 18:00:29 +0300
From: David Baron <d_baron@012.net.il>
Subject: RE: 2.6.21-rt7 Oopses
X-012-Sender: d_baron@012.net.il
To: linux-audio-user@lists.linuxaudio.org
Cc: linux-kernel@vger.kernel.org
Message-id: <200705301800.29903.d_baron@012.net.il>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Verrry eeeenteresting (showing my age):

Kdiff3 if fantastic. Looked at the entire source tree for -rt1 and -rt7. Found 
nothing changed touching any of the "oopses" that I have seen. What has been 
added, however, seems to be the trace-back code to display them. (Hypervisor 
code has been removed but my PIII clunker has no kvm support in any event.)

Am I correct?
These displayed "oopses" are problematic or simply debugging messages?
They seem to not have effected anything outside of my log files :-)
Safe to ignore them and keep using -rt7 or wait on this?
