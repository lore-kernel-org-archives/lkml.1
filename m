Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZKCFtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZKCFtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKCFtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:49:00 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:64706 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZKCFs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CCKxQojo5WPh2foCe4etVXPFp8drpS7fROiSOJSamTPaR04/XIz47QhMuft5YSzn6A
         wRXkGMR8Mi1MKAQ1yjObz+VbketT5OF/sd3DIPMqdvehcLWjmluLNulvS5qE7egQccAD
         4MLn9VSszrhJEmJbsYI3yuTbuH8+HAJELo/Eo=
MIME-Version: 1.0
Date: Tue, 3 Nov 2009 11:19:03 +0530
Message-ID: <ba5648fa0911022149y544fcfbcsd81a68a731f0604c@mail.gmail.com>
Subject: Attending skype calls from bluetooth headset
From: bluezprofile kernel <bluezprofile@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I am trying to attend skype calls from bluetooth headset.
I am hearing the ringtone but I am not able to answer the call by
pressing the call button in the headset.

Control comes to function telephony_key_press_req() in
audio/telephone_dummy.c [bluez 4.32] when call button in the headset
is pressed.
Any idea how to communicate this event to skype so that the call can
be answered?

Regards,
Bala.
