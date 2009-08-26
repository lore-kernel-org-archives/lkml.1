Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZHZG4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZHZG4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZHZG4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:56:37 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:48131 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbZHZG4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C/s9QnRA0+5+fMnhOORjES9L2DUn/6ehEKKLon9zbE178luf1I/K8buwN8L1b6CAPo
         KJGWj6DArR/bVCnvBkq3ORoLBZOeTaMoNQZsqtDE4HeiDXJot2KaWRnZ1EMV4X2IYral
         1I+5yVNE6lvWHKBiTnVRmgQ2pK12riGz4V/RA=
MIME-Version: 1.0
In-Reply-To: <20090826052647.GB18777@kroah.com>
References: <1251068150-15001-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <20090826052647.GB18777@kroah.com>
Date: Wed, 26 Aug 2009 03:49:40 -0300
X-Google-Sender-Auth: e3f568dbff73fcc9
Message-ID: <6b53b1990908252349p12fb5164m3a52707492120ff8@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: remove unused variable
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Aug 26, 2009 at 2:26 AM, Greg KH<greg@kroah.com> wrote:
> On Sun, Aug 23, 2009 at 07:55:50PM -0300, Gustavo F. Padovan wrote:
>> struct usb_serial *serial is not used.
>>
>> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
>
> What kernel version is this patch against?  I think this is already
> fixed in linux-next, right?

Yes, it was fixed in linux-next.

>
> thanks,
>
> greg k-h
>


-- 
Gustavo F. Padovan
http://padovan.org
