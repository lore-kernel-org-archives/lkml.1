Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbYBTVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbYBTVtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbYBTVtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:49:01 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35993 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbYBTVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:49:00 -0500
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Message-Id: <D0D8B4F8-4241-4664-B8DC-E90F77819C5F@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080220132050.8f1dac05.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 1/2] firmware: move firmware_class from Documentation/ to samples/
Date: Wed, 20 Feb 2008 22:48:54 +0100
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com> <20080220064642.GA22884@kroah.com> <47BC893C.6060309@oracle.com> <20080220204001.GB15787@kroah.com> <20080220132050.8f1dac05.randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> Move the firmware_class sample drivers to samples/ so that they are
> buildable and can be maintained.  Add Kconfig entry for  
> firmware_class.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

this is a good idea.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

