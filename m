Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYJ2Vpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYJ2Vpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYJ2VpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:45:21 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60222 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbYJ2VpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:45:20 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <200810292211.49021.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
	 <200810292211.49021.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Thu, 30 Oct 2008 08:45:15 +1100
Message-Id: <1225316715.18786.1.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2008-10-29 at 22:11 +0100, Rafael J. Wysocki wrote:
> The current design of the freezer is rather simplistic and I'm not really sure
> it's the best one possible.  Perhaps we can redesign the freezer to work
> differently and handle the cases like fuse.

Why redo what I've already done? In the full patch, you have the basis
of what you're talking about. I haven't seen a failure to freeze fuse or
anything else in a year of use.

Nigel

