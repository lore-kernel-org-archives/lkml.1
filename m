Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYDJTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYDJTeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYDJTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:34:09 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:45483 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYDJTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:34:08 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for April 10: generic pci_enable_resources() strikes again
Date: Thu, 10 Apr 2008 21:34:00 +0200
User-Agent: KMail/1.9.7
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804102134.00997.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

	The commit b818da52 makes my sparc64 box simply unable to boot.
You should probably take a look at other arches as well. The story is here:

http://lkml.org/lkml/2008/3/28/465
http://lkml.org/lkml/2008/4/1/248

	Mariusz
