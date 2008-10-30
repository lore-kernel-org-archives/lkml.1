Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYJ3O6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYJ3O6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYJ3O6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:58:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:49739 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYJ3O6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:58:24 -0400
Message-ID: <ac3eb2510810300758yf0df0e8j43875dd7c98a56c@mail.gmail.com>
Date: Thu, 30 Oct 2008 15:58:21 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: s390: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20081030113831.GA3871@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225328227.5970.51.camel@nga.site>
	 <20081030103200.438576a1@gondolin>
	 <20081030113831.GA3871@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:38, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Thu, Oct 30, 2008 at 10:32:00AM +0100, Cornelia Huck wrote:
>> On Thu, 30 Oct 2008 01:57:07 +0100,
>> Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> > From: Kay Sievers <kay.sievers@vrfy.org>
>> > Subject: s390: struct device - replace bus_id with dev_name(), dev_set_name()
>> >
>> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
>> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>> > Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
>>
>> Other than the fact that this patch is a bit mis-named (it just gets
>> rid of BUS_ID_SIZE), this looks fine to me.

Yeah, sorry, it's one of the 49 patches, where the subjects isn't
right, because you did the conversion already. :)

> Who is supposed to send this upstream and when?

Would be fine if it goes through the s390 tree, and gets merged there
soon so it shows up in -next.

Thanks,
Kay
