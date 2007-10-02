Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbXJBOME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbXJBOME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXJBOLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:11:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:4525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXJBOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZqnP6Ry5kK6R0o4eWZQhM78FSA3HIkD75uRaKKo3yEwQ8by8Mk/Wz3qeHLxSiC4DcwNnBXry7zQTaoOPh7QhfrnCDbBYE1Oq7704Di6ju2n9R/HugdA0OtVu5/D5y819CMxJsKPUQ8nEbFKWzAW8ihqOiGrK67UqyIAcNTLn2Ic=
Message-ID: <b6fcc0a0710020711o49f54053h23ff183194f266a0@mail.gmail.com>
Date: Tue, 2 Oct 2007 18:11:49 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [patch] menuconfig - lift the fs menu
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0710021549421.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710021549421.7130@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Lift the FS menu a bit by moving filesystem-specific
> parts into their own menu.

I personally prefer fs menu as-is. There is only one reiserfs,
only one XFS. only three ext filesystems...
