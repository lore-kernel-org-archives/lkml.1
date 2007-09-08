Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbXIHRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbXIHRG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXIHRGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:06:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39567 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbXIHRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Hz797rTPA/nVG2W8dbv5nJfAKZjHlm14wUjniv1gK9AVozMQ2ZbrRr9yI9paNImNOeewaE2aOnFJ6Wwg82Z5PHfUfSyh+/BgC5n3hF9t6SWvnNrpvycQfO33GxPiOque/90QidxUbZPLtp0DZbTpxxue0GL99Zq3gODMXqYIwZU=
Message-ID: <46E2387F.4020404@gmail.com>
Date: Sat, 08 Sep 2007 14:51:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: "Gaston, Jason D" <jason.d.gaston@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel
 Tolapai
References: <200708302127.19535.jason.d.gaston@intel.com> <46D7C783.8050803@pobox.com> <39B20DF628532344BC7A2692CB6AEE0701B9A4CA@orsmsx420.amr.corp.intel.com> <46E1D313.2060302@pobox.com> <39B20DF628532344BC7A2692CB6AEE0701BCF3B5@orsmsx420.amr.corp.intel.com> <46E1E559.4000702@pobox.com>
In-Reply-To: <46E1E559.4000702@pobox.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Gaston, Jason D wrote:
>> At this time, I don't have any way to test those particular DeviceID's
>> and I know that the AHCI mode DeviceID works by using the class code
>> support.  So, I would like to just leave them at they are, if that is
>> ok.
> 
> 
> Fine by me...  Overall I'll follow "vendor's best advice" here :)

The distinction between board_ahci and board_ahci_pi has been removed in
#upstream anyway, so it doesn't matter too much anyway.

Thanks.

-- 
tejun

