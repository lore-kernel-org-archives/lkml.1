Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYGQNNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYGQNNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYGQNN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:13:28 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:19255 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYGQNN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:13:27 -0400
Message-ID: <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
Date: Thu, 17 Jul 2008 09:13:26 -0400
From: "Josef Bacik" <josef@toxicpanda.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, "Johannes Weiner" <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 8:51 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I get this with both clean v2.6.26 and latest -git
> (33af79d12e0fa25545d49e86afc67ea8ad5f2f40):
>

Thanks for the report, do you happen to have any messages above the
panic message that would indicate if there was some sort of fs error
that was hit before the panic?  That would help me figure out what
exactly happened.  Thanks,

Josef
