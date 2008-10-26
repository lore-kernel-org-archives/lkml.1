Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYJZRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYJZRYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYJZRY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:24:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYJZRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WyxA/nbe84/JYSN6diHMVlzUH+25LkacwPwHnNklLIT/bakwaM6sPROlN2RVWZnVTL
         RUxMA5paeo+S/S5k3Vg30A2uWKDqzZGIubGBqQnuLE7sqN74Q0VdkY1TkV2A6mI1Q6F4
         Dxpso+TBcRfU0i8FeyuyEq3ckLXAh1wvA8qDo=
Message-ID: <4904A7C5.7090801@gmail.com>
Date: Sun, 26 Oct 2008 18:24:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk> <4903947A.3060206@gmail.com> <20081025223443.GA30913@electric-eye.fr.zoreil.com>
In-Reply-To: <20081025223443.GA30913@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2008 12:34 AM, Francois Romieu wrote:
> It may go away if one comments out rtl_init_mac_address in rtl8169_init_one

Hmm, no. How can one restore eeprom contents without making a brick from the
notebook? I seem to have all zeroes in the eeprom mac address area.
