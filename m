Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYEVUks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYEVUks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYEVUkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:40:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53851 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbYEVUkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:40:20 -0400
Date: Thu, 22 May 2008 22:40:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH] apm_emu: push BKL down into ioctl handlers
Message-ID: <20080522204059.GB24212@uranus.ravnborg.org>
References: <20080522212341.6527256c@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522212341.6527256c@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:23:41PM +0100, Alan Cox wrote:
> Part of the elimination of the old lock based ioctl. This one can
> probably lose the remaining BKL pretty trivially
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
-ENOPATCH

	Sam
