Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZFSWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZFSWto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757032AbZFSWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:49:27 -0400
Received: from kroah.org ([198.145.64.141]:46295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbZFSWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:49:26 -0400
Date: Fri, 19 Jun 2009 15:45:24 -0700
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
Message-ID: <20090619224524.GB27322@kroah.com>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245450702-31343-1-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:31:21PM -0700, Sage Weil wrote:
> This is a patch series for v0.9 of the Ceph distributed file system
> client (against v2.6.30).

Oh, one other question, why put this in staging?  What is keeping it
being accepted into fs/ like normal?

thanks,

greg k-h
