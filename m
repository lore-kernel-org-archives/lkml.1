Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXAXWqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXAXWqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXAXWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:46:54 -0500
Received: from agmk.net ([87.236.194.20]:4041 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXAXWqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:46:53 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
Date: Wed, 24 Jan 2007 23:46:44 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701242346.44673.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
disabling the "amd-k8 cool'n'quiet" option in bios helps.
moreover, it works fine for 2.6.17.13, so it looks like
a recent regression. i can provide more details if you need.

BR,
pawel.
