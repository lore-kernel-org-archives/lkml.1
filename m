Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZENWbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZENWbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZENWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:31:39 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:34469 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZENWbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:31:38 -0400
Date: Fri, 15 May 2009 00:31:38 +0200
Message-Id: <716147033@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: bart.vanassche@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       philipp.reisner@linbit.com
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19p9WKaR2eEqoFmwS8BEpu2GzhrFydvNNkm0smpGVkpfXXgv
 hK1g3LwTlpizpBDTOKWpTZZwUq4DrtiqcXigxI6Sts+9s44WYo=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
><akpm@linux-foundation.org> wrote:
>> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
>>
>>> This is a repost of DRBD
>>
>> Is it being used anywhere for anything?  If so, where and what?
>
>One popular application is to run iSCSI and HA software on top of DRBD
>in order to build a highly available iSCSI storage target.
>
>Bart.

Iirc, Xtravirt`s XVS Virtual SAN appliance is built around DRBD.

For those interested:

Some Blog entry:
http://vmetc.com/2008/05/23/xtravirt-xvs-creates-a-free-san-out-of-local-esx-vmfs/

Design sheet:
http://communities.vmware.com/servlet/JiveServlet/download/950436-9486/xvsrefdiag.jpg

Discussion:
http://communities.vmware.com/message/1114092#1114092

Seems to be sold to PHD Virtual Technologies now....

regards
roland

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

