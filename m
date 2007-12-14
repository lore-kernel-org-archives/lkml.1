Return-Path: <linux-kernel-owner+w=401wt.eu-S1763228AbXLNDXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763228AbXLNDXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbXLNDXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:23:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:40917 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXLNDXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QreJAc14aTIXQtyJM515iek38gOu2q6N6vKtvMjnFKejh3vVd37Bh5AWiVBnBYP64kvnKdHUYrVOV2bgNGtZAeaV710n3kgTJkKscwZyYdN8Y5IrWHHyE5gizzsoRGotxuwK8a7mKNlkrJQJrU/IvWMMMRQOjRiKCukU+sF/wMk=
Message-ID: <a44ae5cd0712131923q2069e1c9h2c55117840b1840c@mail.gmail.com>
Date: Thu, 13 Dec 2007 22:23:05 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: =?WINDOWS-1252?Q?Re:_2.6.24-rc5-mm1_--_drivers/v?= =?WINDOWS-1252?Q?ideo/logo/logo=5Flinux=5Fclut224.c:5?= =?WINDOWS-1252?Q?98:_error:_conflicting_type_qua?= =?WINDOWS-1252?Q?lifiers_for_=91logo=5Flinux=5Fclut224=92?=
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071213175736.674e3189.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712131716n39d29ec4qa0dfd6ad64a50b0a@mail.gmail.com>
	 <20071213175736.674e3189.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 8:57 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 13 Dec 2007 20:16:13 -0500 Miles Lane wrote:
>
> >   CC      drivers/video/logo/logo_linux_clut224.o
> > drivers/video/logo/logo_linux_clut224.c:598: error: conflicting type
> > qualifiers for 'logo_linux_clut224'
> > include/linux/linux_logo.h:47: error: previous declaration of
> > 'logo_linux_clut224' was here
> > make[3]: *** [drivers/video/logo/logo_linux_clut224.o] Error 1
>
> Hi Miles,
>
> Did you try the patch that was posted today?
>
> http://lkml.org/lkml/2007/12/13/439 & click on "Get diff 1"
> on the left side.

No.  Thanks.  I searched on marc.info but didn't find this.
I'll give it a try now.

         Miles
