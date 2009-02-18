Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZBRJvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZBRJvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZBRJvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:51:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:55812 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZBRJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:51:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZU8wCmY50wnbC/eEhMjSyPXlPg/ovK/7l8Y8vUyFcVIOFW+82eQfLksZ1jsU/TKnPX
         IoTIoKVjeMTiqH/b7QtWhlnFxwEf3Vq95D68tfM3O8QQn++e3jI7C/C4I4cXYr1Qak/9
         vTavfxLv/COVHd8o2FQGCxFIamOlXVQ6bK2U4=
Message-ID: <499BDA0A.5000904@gmail.com>
Date: Wed, 18 Feb 2009 10:51:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090208 SUSE/3.0b1-7.1 Thunderbird/3.0b2pre
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-input@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
References: <Pine.LNX.4.44L0.0902171602510.18399-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902171602510.18399-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.2.2009 22:05, Alan Stern wrote:
> On Tue, 17 Feb 2009, Oliver Neukum wrote:
>> Please try the attached patch.
>
> It seems likely that you are seeing the same problem as Laurent in your
> mmotm 2009-02-10-16-35 kernel.  You should try Oliver's patch,
> available here:
>
> 	http://marc.info/?l=linux-usb&m=123490330326229&w=2

Fixes the problem for me. Thanks.
