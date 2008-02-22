Return-Path: <linux-kernel-owner+w=401wt.eu-S935995AbYBVB10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995AbYBVB10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYBVB1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:27:13 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:49662 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYBVB1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F/F9OgFF7si7mJaDKMd931T6gfiadOY4F6PLZzzdUeV/LOZKoLPe75f9ULPf1Z3lBVYoki64stCStfqYNJjf7/LAg9YzW4+OSp/glABjOh5twj0LS1qlh/Lcy3KwVCoi2JxnYznSVXA3uI8TqVgaybxi/lUfc3gXij0CqP/sfiw=
Message-ID: <b6a2187b0802211727qa599c84ka8ef989155a0a49e@mail.gmail.com>
Date: Fri, 22 Feb 2008 09:27:07 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802211702.02306.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211646.31603.jesse.barnes@intel.com>
	 <b6a2187b0802211652x304daa2ci36a76a76a2fcb82@mail.gmail.com>
	 <200802211702.02306.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 9:02 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:

>  The fact that you'd started running into problems since we merged this just
>  means your platform was taking care of it for you (lucky you) and that we
>  have some bugs in the hibernate code that we're just discovering.

That's the main reason for moving to the X series. It's seems to work
very well on Linux.

Thanks,
Jeff.
