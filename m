Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0CJIao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:30:44 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:10146 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0CJIam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:30:42 -0500
X-IronPort-AV: E=Sophos;i="4.49,613,1262581200"; 
   d="scan'208";a="12810798"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Wed, 10 Mar 2010 08:30:37 +0000
Subject: RE: [git pull] Input updates for 2.6.34-rc0
Thread-Topic: [git pull] Input updates for 2.6.34-rc0
Thread-Index: Acq/wEqgeTyyxO0CS1mYfT10j4tJGwAavomw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712D6B1D98DB@LIMKCMBX1.ad.analog.com>
References: <20100301080342.GH765@core.coreip.homeip.net>
 <8bd0f97a1003091013q565f8b1bse66b48d9c9a25600@mail.gmail.com>
 <20100309182013.GC19814@core.coreip.homeip.net>
 <201003091439.49023.rgetz@blackfin.uclinux.org>
In-Reply-To: <201003091439.49023.rgetz@blackfin.uclinux.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote on 2010-03-09:
> On Tue 9 Mar 2010 13:20, Dmitry Torokhov pondered:
>> On Tue, Mar 09, 2010 at 01:13:34PM -0500, Mike Frysinger wrote:
>>> On Tue, Mar 9, 2010 at 13:10, Dmitry Torokhov wrote:
>>>> On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
>>>>> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
>>>>>> On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger
> wrote:
> [snip]
>>>>> i understand the ADXL34x is a bit wonky, but what else would you
>>>>> propose ?  or just leave the driver in limbo forever until people
>>>>> forget about it ?
>>>>
>>>> No, just till we have proper framework for it to be merged into.
>>>
>>> that sounds fine, but is there actually something in progress for
>>> that ?  waiting for a framework no one is working on is the same
>>> in practice ...
>>
>> I have high hopes that IIO will fill the needs of these kinds of
> devices.
>
> The fact of things is that many people are using this as pointing device.
>
> I'm not convinced that IIO is the best place for these types of
> things...

Very true - this driver was originally targeted and designed as a typical human interface input device.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


