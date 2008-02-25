Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbYBYX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbYBYX1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYBYX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:27:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYBYX1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:27:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: REGRESSION: X61s suspend/resume broken sometime between rc2 and rc3
Date: Tue, 26 Feb 2008 00:25:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <E1JTiiw-0002D2-Me@closure.thunk.org>
In-Reply-To: <E1JTiiw-0002D2-Me@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260025.36966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Theodore Ts'o wrote:
> 
> Userspace is Ubuntu Gutsy, with vbetool post/save/restore disabled;
> Hardware is a Lenovo X61s with the Intel graphics chipset.
> 
> Has anyone managed to get suspend/resume (to RAM) working on an X61s on
> rc3?  

http://bugzilla.kernel.org/show_bug.cgi?id=10103 , perhaps?

Rafael
