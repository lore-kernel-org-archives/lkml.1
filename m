Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZLDSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZLDSgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZLDSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:36:17 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:44493 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZLDSgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:36:17 -0500
MIME-Version: 1.0
In-Reply-To: <20091204173902.GK2937@zod.rchland.ibm.com>
References: <20091202091951.5ec6bb83@hyperion.delvare> <1259894454.2076.1246.camel@pasglop> 
	<20091204103434.0a754925@hyperion.delvare> <1259920775.2076.1273.camel@pasglop> 
	<1259947019.22783.116.camel@Joe-Laptop.home> <20091204173902.GK2937@zod.rchland.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 4 Dec 2009 11:36:03 -0700
X-Google-Sender-Auth: 3c3369e99e653b34
Message-ID: <fa686aa40912041036q64c70368oc75e702b819378cd@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add PowerPC patterns
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 10:39 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Fri, Dec 04, 2009 at 09:16:59AM -0800, Joe Perches wrote:
>> LINUX FOR POWERPC EMBEDDED PPC4XX
>> M:    Josh Boyer <jwboyer@linux.vnet.ibm.com>
>>@@ -3221,6 +3228,8 @@ W:       http://www.penguinppc.org/
>> L:    linuxppc-dev@ozlabs.org
>> T:    git git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc-4xx.git
>> S:    Maintained
>>+F:    arch/powerpc/platforms/40x/
>>+F:    arch/powerpc/platforms/44x/
>
> This is mostly complete.  There are a few files under arch/powerpc/sysdev/, and
> arch/powerpc/boot/ as well, but I don't think they're entirely necessary.
>
> For the 4xx parts:
>
> Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
