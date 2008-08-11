Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYHKTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYHKTsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYHKTsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:48:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53296 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYHKTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:48:46 -0400
Subject: checkpoint/restart ABI
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808111853.13854.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	 <200808111853.13854.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 12:48:34 -0700
Message-Id: <1218484114.5598.43.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Jeremy and Oren,

Thanks for all of the very interesting comments about the ABI.  

Considering that we're still *really* early in getting this concept
merged up into mainline, what do you all think we should do now?

My main goal here is just to get everyone to understand the approach
that we're proposing rather than to really fix the interfaces in stone.
I bet we're going to be changing them a lot before these patches
actually get in.

-- Dave

