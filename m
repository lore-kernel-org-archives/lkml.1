Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYHRQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYHRQnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYHRQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:43:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:11074 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYHRQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:43:13 -0400
Message-ID: <e700089d0808180943m1bc403d4v3ee578a81e2d96cf@mail.gmail.com>
Date: Mon, 18 Aug 2008 12:43:10 -0400
From: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
	 <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
	 <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
	 <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
	 <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 8:47 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Aug 18, 2008 at 1:15 PM, Yousaf Jindal <yousaf.jindal@pi.edu.pk> wrote:
>> On Mon, Aug 18, 2008 at 4:12 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>>>
>>> Please try attached patch (not sure it will help tough)
>>> I also will need output of
>>>  >cat /sys/class/net/wlan0/devices/version
>>>
>>>
>>> Thanks
>>> Tomas
>>
>> $ cat /sys/class/net/wlan0/device/version
>> fw not loaded
>> EEPROM version: 0x11e
>>
> Where did you get this card from?
> Thanks
> Tomas
>

The card is included with Asus M50Vm-B2 laptops. ( e.g.,
http://www.newegg.com/Product/Product.aspx?Item=N82E16834220344 )

-- 
Yousaf Jindal
Director of Technology
Pakistani Institute
