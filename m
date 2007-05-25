Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXEYGsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXEYGsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXEYGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:48:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:25202 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXEYGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iwtT+S9hVd5TXJaFI9OVxVkIrfkxEm0NwZPhu0vGO+VxcUfQDwi9qv/4vmPyld/zZKJ09j9C5oxJQFNapr/zs+C+KBTWarTXM4Xl9samESwGdZefa+DDsGiduWziwOd4B6W+F/yVO87trIF2vwTVPV+t/cLA3OiOqLm647FFwvM=
Message-ID: <a8e1da0705242348n12aebed7m254677969d718bde@mail.gmail.com>
Date: Fri, 25 May 2007 06:48:34 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Anton Altaparmakov" <aia21@cantab.net>
In-Reply-To: <20070524234353.ad493d42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	 <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	 <a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
	 <20070524224709.0719acfe.akpm@linux-foundation.org>
	 <a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
	 <20070524234353.ad493d42.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I'm sure.  but the patch in top post of mine works, the diffrence
is using kzalloc and remove the  "ni->name[i] = 0;" line.

Regards
dave
