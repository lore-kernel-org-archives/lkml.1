Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYF0Lfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYF0Lfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYF0Lf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:35:28 -0400
Received: from sirf.com ([125.16.220.82]:62096 "HELO bnglmail.sirf.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756842AbYF0Lf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:35:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Time drifting after multiple sleep/wakeup in timekeeping
Date: Fri, 27 Jun 2008 17:05:22 +0530
Message-ID: <013B1C915F9462459242424413ABB264011ACAE8@bnglmail.sirf.com>
In-reply-to: <e2e108260806270405u28cb14bcl46713157a5ef4155@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Time drifting after multiple sleep/wakeup in timekeeping
Thread-Index: AcjYRinqNVsYBIi/SuCToWOyy4M7DAAA6wyg
From: "Mayank Sharma" <mayanks@sirf.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>, <linux-arm@lists.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You mean on non-ARM platforms ? No I have not verified it

-Mayank 

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Bart Van Assche
Sent: Friday, June 27, 2008 4:36 PM
To: Mayank Sharma
Cc: lkml; linux-arm@lists.arm.linux.org.uk
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping

On Thu, Jun 26, 2008 at 10:00 AM, Mayank Sharma <mayanks@sirf.com> wrote:
> I have observed this behaviour on 2.6.23-17. The diff in my earlier mail was with the latest kernel.
>
> I am cc'ing linux-arm on this mail. In my opinion the problem was not restrictive to ARM and hence I posted this message in the linux-kernel list.

Have you already been able to verify  this ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
