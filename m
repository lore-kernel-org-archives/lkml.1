Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbZDQAun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbZDQAun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZDQAuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:50:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:50545 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZDQAub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=nGd7vmX1sm4rJxN6YGezA80zUBHhiyiI1+vwY1b4affJ1iDH8gS1YxSth7KZcx1s9n
         FYAkFFYUKmwJ7Q04UDmXYCBnMIdLnwHkYDYRjEIUFcOV4d1J9ZU1IzzvVqL1+Uf8YI3N
         mtucjtZsR/3OWZj84r6DIj5oJJbbR8YsnTp7g=
Cc: linux-kernel@vger.kernel.org
Message-Id: <C2111E25-C51B-4AB1-96F5-A7C313B4B487@gmail.com>
From: Robert Nicholson <robert.nicholson@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20090417004633.GB869@srcf.ucam.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Does the linux kernel contain support for ATA Security feature set?
Date: Thu, 16 Apr 2009 19:50:14 -0500
References: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com> <20090417004633.GB869@srcf.ucam.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So you're implying that it is possible to do a SECURE_ERASE using  
hdparm then.

I don't know why but HDDERASE tool requires legacy IDE mode.

On Apr 16, 2009, at 7:46 PM, Matthew Garrett wrote:

> On Thu, Apr 16, 2009 at 06:49:59PM -0500, Robert Nicholson wrote:
>> So, I've got an X-25M that I want to securely erase and it turns out
>> on a Mac I'm not going to be able to issue the command because it
>> doesn't support legacy IDE mode from what I understand. So the idea  
>> of
>> a any boot CD that I could boot and run a program that can issue a
>> SECURE_ERASE (SE) to the drive is only applicable to PC's.
>
> Why is the lack of legacy IDE an issue? hdparm works fine with SATA
> setups.
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

