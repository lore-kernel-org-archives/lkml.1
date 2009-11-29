Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZK2JKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZK2JKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZK2JKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:10:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZK2JKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:10:13 -0500
Message-ID: <4B123A34.5090509@redhat.com>
Date: Sun, 29 Nov 2009 10:09:08 +0100
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
References: <4B110F79.8080405@redhat.com> <4B111ADC.9020800@garzik.org>
In-Reply-To: <4B111ADC.9020800@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2009 13:43, Jeff Garzik wrote:
> On 11/28/2009 06:54 AM, Stefan Assmann wrote:
>> From: Stefan Assmann<sassmann@redhat.com>
>>
>> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
>> terms listed in the "Trademark and Logo Usage Guidelines".
>> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
>>
>> Additionally some renames of Gb/s to GT/s where appropriate, concerns
>> PCIe.
>>
>> This is a followup to the discussion at:
>> http://lkml.org/lkml/2009/10/14/107
>> Patch is based on 2.6.32-rc8.
>>
>> Signed-off-by: Stefan Assmann<sassmann@redhat.com>
> 
> NAK, this clearly introduces bugs and changes sysfs output (ABI).
> 
> Typically this type of change is pointless churn that creates far more
> problems than it "solves."

Hi Jeff,

I see you point in not liking this kind of change. What kind of cleanup
would be ok in your opinion?

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
