Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZKYJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZKYJiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbZKYJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:38:08 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:54045 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480AbZKYJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:38:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cfwu7UjBxpkH0od8SBOIlgpkGzjwBZRzJuUir1mDhZ0dP8hlSRLOGRE8OJFT15/aFc
         oKlE1smAbgPfMN//CSy58OXnTJA1Zf/6gyM+OBSuNEnLMN3sQCi4T7uGCCn6Jqhxzhs4
         7xpuV4fqkVTD2e517xNB+pYIZnU6r4+gdsh8U=
Date: Wed, 25 Nov 2009 04:37:57 -0500
From: tmhikaru@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: tmhikaru@gmail.com, Alan Stern <stern@rowland.harvard.edu>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Message-ID: <20091125093757.GA28839@roll>
References: <20091124195607.GC16662@quack.suse.cz> <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org> <20091124203944.GD16662@quack.suse.cz> <20091124215044.GA20245@roll> <20091124222334.GB20245@roll> <20091125084240.GA549@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125084240.GA549@quack.suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 09:42:41AM +0100, Jan Kara wrote:
>   No, feel free to do anything with it :). Thanks for your help with
> debugging this.

Thank *you* for giving me the initial reply. Without someone telling me they
were at least listening I may have given up entirely.

	Tim McGrath
