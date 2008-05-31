Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYEaOx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYEaOx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 10:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYEaOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 10:53:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYEaOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 10:53:51 -0400
Date: Sat, 31 May 2008 10:47:15 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080531144715.GA22616@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <20080531003214.GA6208@suse.de> <20080531003250.GB6208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531003250.GB6208@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 05:32:50PM -0700, Greg KH wrote:
 > 
 > Looks like this adds a new device id, I have no idea why they remove
 > another one at the same time...

I sent a patch adding the missing ident to airlied a few weeks back.
I think it's currently in -mm.

The removal of the other id is a mystery to me.

	Dave

-- 
http://www.codemonkey.org.uk
