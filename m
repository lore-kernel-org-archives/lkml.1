Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXDXLLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXDXLLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXDXLLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:11:41 -0400
Received: from mail.suse.de ([195.135.220.2]:55754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXDXLLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:11:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Kara <jack@suse.cz>
Subject: Re: BUG: Dentry still in use during umount in 2.6.21-rc5-git6
Date: Tue, 24 Apr 2007 13:11:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200704202348.39357.ak@suse.de> <20070424104024.GF1330@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20070424104024.GF1330@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241311.35869.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 12:40:24 Jan Kara wrote:
> > One of my autoboot test clients gave me this during shutdown. It used
> > reiserfs and autofs and NFS heavily.
>   Jeff has a fix for this bug so it should go away soon... Thanks for
> report anyway :).

Well I hit two more -- see other mails if you're interested.

-Andi

