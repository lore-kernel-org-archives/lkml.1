Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864Ab0AEP0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0AEP0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742Ab0AEP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:26:43 -0500
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:43359 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754339Ab0AEP0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:26:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] drivers/net/stmmac/gmac.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 10:26:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090208923F@mi8nycmail19.Mi8.com>
In-Reply-To: <4B42F226.6010207@st.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/stmmac/gmac.c: use %pM to show MAC address
Thread-Index: AcqN3YI3T1AgjmeTShmQ0tVDhhiLFwAPOD0g
References: <BD79186B4FD85F4B8E60E381CAEE19090200F674@mi8nycmail19.Mi8.com> <4B42F226.6010207@st.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Giuseppe CAVALLARO" <peppe.cavallaro@st.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 05 Jan 2010 15:26:40.0082 (UTC) FILETIME=[7A503B20:01CA8E1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 05, 2010 1:03 AM, Giuseppe CAVALLARO wrote:
> Hi Hartley,

Hello.

> H Hartley Sweeten wrote:
>> Use the %pM kernel extension to display the MAC address.
>
> Thanks for this patch.
> As discussed in the mailing list, I'm reworking some patches for the
> stmmac driver (fixing compilation errors and trying to make the code
> more generic).
> I've already modified the gmac.c file now splitted in new two files.
> So I'm wondering if it's worth applying this patch into the new code,
> directly.

Feel free to apply this with your new code.

I am resubmitting a number of the %pM patches to David and will drop
this one for now.  If you don't get a chance to submit the updated
gmac.c soon please let me know and I will repost this patch.

Thanks,
Hartley
