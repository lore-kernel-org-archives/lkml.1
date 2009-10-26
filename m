Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZJZSWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZJZSWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZJZSWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:22:11 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45649 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZJZSWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LXL6WfERyp9f7Db/mt4UOJ0v7pHD6BaXene55wCbdWGWLDmCSZ5uE0Emfgu3mQ8wW5
         HyhThKDUPBNgfsP8JqkenLcuQL5D9HVF5moZORj2YbWEqgXhDaHnQW5DwkoXzSFCQR1o
         gPFj9DMWaRyvVZ6Nm8g34dfynqAzX6vIyzapI=
MIME-Version: 1.0
In-Reply-To: <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>
	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>
Date: Mon, 26 Oct 2009 23:52:14 +0530
Message-ID: <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
Subject: Re: Difference between atomic operations and memory barriers
From: "Leonidas ." <leonidas137@gmail.com>
To: Noah Watkins <noah@noahdesu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:49 PM, Noah Watkins <noah@noahdesu.com> wrote:
>> Trying to understand difference between atomic ops and memory barriers.
>>
> There is a bit of info in:
>    Documentation/atomic_ops.txt
>
> -noah
>
>


Thanks for the pointer, there are no atomic operations for pointers, right?
I guess barrier is what we need in that case.

-Leo.
