Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZBRU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZBRU7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZBRU7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:59:00 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:4746 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZBRU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DVvT6K+mEJoBpSLbZ84Z0d+pf5mXx72wJrcvWZ9BkzPD5ZML+s9PWqKGtiat0L1Jvo
         88E6A5Q1zydyDUKe4I7U/3aZT16MQi07hBTcNVV+wlGj5srr/eEjZ3ZtFLjCSpnjwJ23
         CkHw1zJFmLmlEYEuAzG16LgioGdX3q3e4BaRw=
MIME-Version: 1.0
In-Reply-To: <20090218194007.GA26837@kroah.com>
References: <9b5c9bb30902172334o1ae3951i7daf4de65b428434@mail.gmail.com>
	 <20090218194007.GA26837@kroah.com>
Date: Thu, 19 Feb 2009 04:58:57 +0800
Message-ID: <9b5c9bb30902181258u76091d7crc1ceb53e0c460317@mail.gmail.com>
Subject: Re: Reference to inexistent struct dmi_device_id breaks the build 
	into 2.6.28-stable
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 3:40 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Feb 18, 2009 at 03:34:51PM +0800, Teck Choon Giam wrote:
>> Hi,
>>
>> Sorry if this is not the right place to ask.  I am curious about when
>> the "Reference to inexistent struct dmi_device_id breaks the build"
>> (http://bugzilla.kernel.org/show_bug.cgi?id=12483) fix going into
>> 2.6.28-stable tree?  I just checked 2.6.28.6 and it isn't there.
>
> No one has submitted it to the stable@kernel.org address for them to
> know to pick this up :(
>
> I'll go take care of it...

Thank you ;)

Kindest regards,
Giam Teck Choon
