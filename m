Return-Path: <linux-kernel-owner+w=401wt.eu-S934218AbYBUQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbYBUQhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764237AbYBUQh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:37:26 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:21901 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764436AbYBUQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z/lkznMOKx6GUj0gE/eLkCVwt+ZvygfbiyfAIE+tEuP0Nv7wQtvcn5kYrZX0NNXBwavMAiBu+yavIB2vqkMkTZVw8mUpY+smmGz39j5jyA9L3SrEb62Qiy1ANn00M/ZCc8qbJiv079xY/bi99ZuIzV+4qiEKtTc/F+8N3bXRx9k=
Message-ID: <45a44e480802210837o6caa9a9k8b26825b31cbf54d@mail.gmail.com>
Date: Fri, 22 Feb 2008 00:37:19 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH 2/2] xen pvfb: Para-virtual framebuffer, keyboard and pointer driver
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <87skzmd4qc.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <871w76ejdg.fsf@pike.pond.sub.org>
	 <87skzmd4qc.fsf@pike.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 5:43 PM, Markus Armbruster <armbru@redhat.com> wrote:
>  +config XEN_FBDEV_FRONTEND
>  +       select FB_DEFERRED_IO

Groovy. :-)

Thanks,
jaya
