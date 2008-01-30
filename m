Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYA3S0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYA3S0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYA3S0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:26:31 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:42436 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYA3S0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:26:30 -0500
Message-ID: <47A0C138.2070807@nortel.com>
Date: Wed, 30 Jan 2008 12:26:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Giridhar Pemmasani <pgiri@yahoo.com>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com> <20080130175447.GB29368@does.not.exist>
In-Reply-To: <20080130175447.GB29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 18:26:04.0866 (UTC) FILETIME=[92FC6A20:01C8636D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

> IANAL, but I have serious doubts whether putting some glue layer between 
> the GPL'ed code and the code with a not GPL compatible licence is really 
> a legally effictive way of circumventing the GPL.

It may depend on the details of the "code with a not GPL compatible 
licence".

It's pretty hard to argue that a binary driver written for another OS is 
a derivative work of the linux kernel.

Chris
