Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZDHWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZDHWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZDHWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:05:57 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:49806 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZDHWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K96wy3A3CDLLUb5zyRJoNWktsmXJpFLKGldjamFdOQe4ccMAy3qb+MRleEK8Q+ek3F
         lgSdNQ7CQuJ6D4PINLYthoCePBHjUk35D//8lTka/3U5lgPnwEjxdTQtRIlqOAHUAjgD
         Mw18W3z50pz6gHwh0jm8jWpmS5bStKxhbshWw=
MIME-Version: 1.0
In-Reply-To: <49DCDF1F.5050805@xandros.com>
References: <3d2f29dc0904071551xadea34ajd2c177380ced4fef@mail.gmail.com>
	 <49DCDF1F.5050805@xandros.com>
Date: Wed, 8 Apr 2009 18:05:55 -0400
Message-ID: <3d2f29dc0904081505l4e0203a0q25144d200164c82a@mail.gmail.com>
Subject: Re: Weird freezes with 2.6.28/29
From: Chris Howie <cdhowie@gmail.com>
To: Woody Suwalski <woodys@xandros.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 1:30 PM, Woody Suwalski <woodys@xandros.com> wrote:
> I am getting similar problem on Dell 4x00 laptops caused by loading
> processor.ko.
> If I use nocst=1 option, systems are OK.

Thanks, this has eliminated the second freeze (where I must hold down
a key to allow boot to proceed) but I still have to hit the power
button to get the initial boot going.

Getting closer!

-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
