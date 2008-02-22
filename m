Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbYBVBCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbYBVBCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964940AbYBVBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:01:49 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:20732 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923AbYBVBBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CKOxNfWQTx2rWTtCp1/lobb22GzFoSWUS54Q0niSxQZrURisywMwkpmOEPzRI8/MepL4UulMxcD1kX1Fpv5xGHBg57TbkzwcPowW7289BGZ1BtFmRY9jj0mKyXTImu4cQAF0y2Zn2C5XtSKtao4AKK0Dk3Y0qOkx78Rwm+82rVI=
Message-ID: <b6a2187b0802211701p59b427aft694ace922e8c3c90@mail.gmail.com>
Date: Fri, 22 Feb 2008 09:01:45 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <b6a2187b0802211642i7f4cd764ocb5a66b49de78875@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211302.27002.jesse.barnes@intel.com>
	 <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
	 <200802220131.09525.rjw@sisk.pl>
	 <b6a2187b0802211642i7f4cd764ocb5a66b49de78875@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 8:42 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Fri, Feb 22, 2008 at 8:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>  >  Jeff, can you please test hibernation with the patch I've just sent to Jesse
>  >  (reproduced below for convenience)?
>
>  Testing now.

Great news. It works. STD (platform) does not hang at suspend. And the
annoying green is gone! STR still works.


Thanks,
Jeff.
