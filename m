Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYHRMr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYHRMr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHRMrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:47:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:46293 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYHRMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jOFWncH1I8Hle6DcOC668FZld9HK7ddAOzm5ShfWMSbSDtlRDzP5wapAIK7MP6DYwa
         djV5qqy2zWaxXoWL+paXnEx9Qj9H8dJrFsJDSdfpLTLHHVr171X71JmCk6u/R3lieUOV
         PWebjwJKXqIAQMnkIAlvGqSyaM62jXTzqIkdQ=
Message-ID: <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com>
Date: Mon, 18 Aug 2008 15:47:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
	 <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
	 <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
	 <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 1:15 PM, Yousaf Jindal <yousaf.jindal@pi.edu.pk> wrote:
> On Mon, Aug 18, 2008 at 4:12 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>>
>> Please try attached patch (not sure it will help tough)
>> I also will need output of
>>  >cat /sys/class/net/wlan0/devices/version
>>
>>
>> Thanks
>> Tomas
>
> $ cat /sys/class/net/wlan0/device/version
> fw not loaded
> EEPROM version: 0x11e
>
Where did you get this card from?
Thanks
Tomas
