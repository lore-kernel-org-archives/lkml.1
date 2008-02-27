Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbYB0XjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbYB0XjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760262AbYB0Xiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:38:46 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43101 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077AbYB0Xip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:38:45 -0500
Date: Wed, 27 Feb 2008 18:38:22 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: X61s suspend/resume broken sometime between rc2
	and rc3
Message-ID: <20080227233822.GF8840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <E1JTiiw-0002D2-Me@closure.thunk.org> <200802260025.36966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802260025.36966.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 12:25:36AM +0100, Rafael J. Wysocki wrote:
> On Monday, 25 of February 2008, Theodore Ts'o wrote:
> > 
> > Userspace is Ubuntu Gutsy, with vbetool post/save/restore disabled;
> > Hardware is a Lenovo X61s with the Intel graphics chipset.
> > 
> > Has anyone managed to get suspend/resume (to RAM) working on an X61s on
> > rc3?  
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10103 , perhaps?

Yes, that was it, thanks!!

					- Ted
