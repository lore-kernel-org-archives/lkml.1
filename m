Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYCHTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYCHTOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYCHTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:14:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47747 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbYCHTOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:14:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Subject: Re: suspend not working on macbook pro
Date: Sat, 8 Mar 2008 20:13:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080308110626.GE4491@ojjektum.uhulinux.hu>
In-Reply-To: <20080308110626.GE4491@ojjektum.uhulinux.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082013.03516.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of March 2008, Pozsar Balazs wrote:
> 
> Hi all,

Hi,

> I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> suspend. The console is still on, the disk is powered off, but no 
> response or poweroff...
> 
> Did anyone else met the same thing? How could I help debug it?
> What other info would you need?

Can you please verify if the problem also happens with 2.6.24.x?

Thanks,
Rafael
