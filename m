Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYH2G0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYH2G0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYH2GWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:22:20 -0400
Received: from vuizook.err.no ([194.24.252.247]:58354 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbYH2GWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:22:18 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 02:22:18 EDT
Date: Fri, 29 Aug 2008 07:50:00 +0200
From: Mike Hommey <mh@glandium.org>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
Message-ID: <20080829055000.GB18930@glandium.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org>
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
Organization: glandium.org
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 03:18:59AM +0900, Tejun Heo wrote:
> This patchset implements CUSE - Character device in Userspace.  Except
> for initialization sequence and creation of character device instead
> of a mount, CUSE isn't very different from FUSE.

It would be nice to have BUSE, Block device in Userspace, too.

Mike
