Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYHFIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYHFIKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYHFIJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:09:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39136 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYHFIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:09:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48995C47.6020808@s5r6.in-berlin.de>
Date: Wed, 06 Aug 2008 10:09:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26 4/25] mdb: Merkey's Kernel Debugger
References: <57474.166.70.238.45.1217815846.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <57474.166.70.238.45.1217815846.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote on 2008-08-04:
> +ULONG displayASCTable(BYTE *cmd,
> +		     StackFrame *stackFrame, ULONG Exception,
> +		     DEBUGGER_PARSER *parser)
> +{
> +
> +     if (cmd) {};
> +     if (stackFrame) {};
> +     if (Exception) {};
> +     if (parser) {};
> +
> +     DisplayASCIITable();
> +     return TRUE;
> +
> +}

Hmm, this construct of empty conditional blocks is new to me.  What is 
its purpose?
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/
