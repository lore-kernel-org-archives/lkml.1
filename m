Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYDNQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYDNQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYDNQLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:11:06 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56129 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYDNQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:11:05 -0400
Date: Mon, 14 Apr 2008 12:11:05 -0400
To: Alexia Death <alexiadeath@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Message-ID: <20080414161105.GA7387@csclub.uwaterloo.ca>
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804140749.57049.alexiadeath@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 07:49:56AM +0300, Alexia Death wrote:
> Yes, Ive come to a conclusion that because reader does not do anything about 
> the speciality of the 2GB cards they wont be readable because Linux usb 
> storage does not know about them either.

The reader in my wife's old laptop (Compaq R3240) would not work with
1gB or 2GB cards, but would work with 512MB and smaller.  It would
detect the card but have random contents displayed and certainly
wouldn't read.  An SD reader in a USB printer on the other hand
connected to the same machine read all the cards fine.  There certainly
are some misdesigned SD readers out there that fail with larger cards
due to having made invalid assumptions.

Sounds like that particular readers is junk and belongs in the trash. :)

-- 
Len Sorensen
