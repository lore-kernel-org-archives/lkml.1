Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0CGPyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 10:54:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37779 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0CGPyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 10:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BymX4BcnYWWkm2rX0f/RHaYrsFMpGu6O9sNPiTTLoPPs5QhXZ0fGYJSM+QPoAz4kjN
         5U5FtCfQ/+Tx5SaImfeuhNnj05HFTRr7kp7fPy2lO8kBrheL0ujli+27nAMXESYFsIub
         v36qmGJe7l6q+QWFHrd9y6tqJOcs/4M8HmhC0=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
Date: Sun, 7 Mar 2010 21:24:49 +0530
Message-ID: <22dbbef21003070754l6c99f777ycd99cfa892169736@mail.gmail.com>
Subject: Re: [PATCH 00/11] Adding Support for SPEAr Platform under ARM 
	architecture
From: viresh kumar <viresh.linux@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Wed, Mar 3, 2010 at 10:37 AM, Viresh KUMAR <viresh.kumar@st.com> wrote:
> Following set of patches are for adding ST Microelctronics SPEAr Platform under
> ARM architecture in Linux.
>
> Hierarchy in SPEAr is as follows:
> SPEAr (Platform)
>        - SPEAr3XX (3XX SOC series, based on ARM9)
>                - SPEAr300 (SOC)
>                        - SPEAr300_EVB (Evaluation Board)
>                - SPEAr310 (SOC)
>                        - SPEAr310_EVB (Evaluation Board)
>                - SPEAr320 (SOC)
>                        - SPEAr320_EVB (Evaluation Board)
>        - SPEAr6XX (6XX SOC series, based on ARM9)
>                - SPEAr600 (SOC)
>                        - SPEAr600_EVB (Evaluation Board)
>        - SPEAr13XX (13XX SOC series, based on ARM CORTEXA9)
>                - SPEAr1300 (SOC)
>
> Current patch will add support for SPEAr3XX and SPEAr6XX family. SPEAr13XX is
> under development phase.
>

Is this patch set fine? Or do i need resubmit it?


regards,
viresh kumar,
ST Microelectronics
