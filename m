Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYAVHjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYAVHjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYAVHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:39:05 -0500
Received: from hu-out-0506.google.com ([72.14.214.225]:11735 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYAVHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:39:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hY6qX8eY3udkgd3aGRhFQVkS1msM7RB33tslT+5SPAF8aNwyzllirc6S8cdIreGjkLdMTcD5nF/xQ2vP1NBobH0CRr0ix0nNXdbSGRaBEXOvgTyIb8rpCk5I5DkOCkc6jaKeHDRkKxLvfnZvciLWtQfxIECXyxyEPd6eVOrO2nk=
Date: Tue, 22 Jan 2008 08:45:36 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080122074536.GA2079@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801211655y5a7313edn331ad4312b0b7de9@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-01-2008 01:55, Dave Young wrote:
...
> Hi, thanks your effort. Now I think we should stop this thread and
> waiting the class_device going away :)

Sure! But, if you change your mind I'm interested in this subject.

Thanks,
Jarek P.
