Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbZARKFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbZARKFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbZARKEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:04:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34526 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173AbZARKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ofhpZ6DqWR91DUsIZVVxKd0PIH9K3kUw9kcJxPAvlk1/piDS76h7C7SnUHaBLyaRIz
         5xMB7UUYb8GKPHyi9i9FoDxT5fygijWx+/jj48x5ik8ydx9luZopXaZXO4WHAVw09btt
         xzKMjyUzrZQ76kmnYfQ9Fw/zkL1jzcDjS1x/c=
MIME-Version: 1.0
In-Reply-To: <71cd59b00812290312u282851eepb1ecc2666d6013ab@mail.gmail.com>
References: <a26244bd6e7cae264155edca7f3c22f8f319b239.1227194932.git.mjg@redhat.com>
	 <20081228152035.GA13424@srcf.ucam.org>
	 <71cd59b00812290312u282851eepb1ecc2666d6013ab@mail.gmail.com>
Date: Sun, 18 Jan 2009 10:04:01 +0000
X-Google-Sender-Auth: 5e291512a4969014
Message-ID: <9b2b86520901180204q29802ec6kd6dceaa165e61555@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] eeepc-laptop: Add support for extended hotkeys
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: lenb@kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Corentin Chary <corentin.chary@gmail.com>, linux-kernel@vger.kernel.org,
       ecc@cmu.edu, linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/08, Corentin Chary <corentin.chary@gmail.com> wrote:
> On Sun, Dec 28, 2008 at 4:20 PM, Matthew Garrett <mjg59@srcf.ucam.org>
> wrote:
>> Hi Len,
>>
>> Can these be merged for .29?
>
> Acked-by: Corentin Chary <corentincj@iksaif.net>

They're not present in 2.6.29-rc2.  Have they just missed the boat?

Thanks
Alan
