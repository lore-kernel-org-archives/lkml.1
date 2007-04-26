Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbXDZIS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbXDZIS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXDZIS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:18:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:50069 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674AbXDZISw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bDONa5KzSbdgeuszXR+VFfTMs8T0BkeBHVt+BlawfHwzJnQmfPcUy82kTZBpnYJvDDUOta2wd4HZMiw2fppgvYJAMHzkkhP86ERhnkXX0vpsNOAj/0GvwFRKm7H2stzJV+4CSklrESuLhdnGKS+HfT/ZzPIiq+vLQ4ajRT2NnGE=
Message-ID: <b6a2187b0704260118x7cf8ed57mab9a12d06a2471a9@mail.gmail.com>
Date: Thu, 26 Apr 2007 16:18:51 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "lkml777@123mail.org" <lkml777@123mail.org>
Subject: Re: Question about Reiser4
Cc: linux-kernel@vger.kernel.org, "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>
In-Reply-To: <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
	 <462E17AF.7090604@namesys.com>
	 <20070424193921.GA17129@one.firstfloor.org>
	 <462F6717.70508@namesys.com>
	 <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com>
	 <1177564182.15467.1186637743@webmail.messagingengine.com>
	 <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll try it with 2.6.21 soon.

Just to inform you that the reiserfs4 patch cleanly on 2.6.21 and
working well. I've not encountered any problem so far.

Thanks,
Jeff.
