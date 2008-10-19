Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbYJSDM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbYJSDM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 23:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYJSDMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 23:12:48 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:51868 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYJSDMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 23:12:48 -0400
Date: Sun, 19 Oct 2008 01:12:36 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: A small and silly question regarding libata
Message-ID: <20081019031236.GB7887@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

I have a small question regarding libata.

Using the plain IDE subsystem the Host Protected Area of a given HD is
disabled and this gives me more room for my files:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
hda: Host Protected Area detected.
	current capacity is 156299375 sectors (80025 MB)
	native  capacity is 156301488 sectors (80026 MB)
hda: Host Protected Area disabled.
hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

What is the current status with libata for PATA devices?


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
