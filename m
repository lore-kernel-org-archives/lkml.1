Return-Path: <linux-kernel-owner+w=401wt.eu-S1423235AbXBHRUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423235AbXBHRUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965732AbXBHRUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:20:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:39886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXBHRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kwIN+dh3V6fYH0crWk2tiL3yrvxUESMJVpvCLfLVI1jluCsMCBoKPerSERtJYDTuVhJnTppovBm+nwlHyHzOaf82kXconytMiz1OebYWyiBl4SxH8eBVIjnGLcgyAbRe9Oa+7G0Fd98lwENWybWH7Xqak9XbmF2i9+Qc55NTD1E=
Message-ID: <d120d5000702080920k5ea09180i8d9608ac1c9857db@mail.gmail.com>
Date: Thu, 8 Feb 2007 12:20:05 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 10/28] SERIO: add the sysfs driver name to all modules
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <11708946533931-git-send-email-greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208002908.GA4796@kroah.com>
	 <1170894620889-git-send-email-greg@kroah.com>
	 <11708946251265-git-send-email-greg@kroah.com>
	 <11708946283719-git-send-email-greg@kroah.com>
	 <11708946362677-git-send-email-greg@kroah.com>
	 <11708946391465-git-send-email-greg@kroah.com>
	 <11708946432920-git-send-email-greg@kroah.com>
	 <11708946472324-git-send-email-greg@kroah.com>
	 <1170894650872-git-send-email-greg@kroah.com>
	 <11708946533931-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 2/7/07, Greg KH <greg@kroah.com> wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
>
> This adds the module name to all SERIO drivers, if they are built into
> the kernel or not.  It will show up in /sys/modules/MODULE_NAME/drivers/
>

What is this needed for?

-- 
Dmitry
